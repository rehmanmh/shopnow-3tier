// OpenTelemetry instrumentation for the ShopNow backend (Node.js/Express)
//
// This file MUST be loaded before any other application code, because
// auto-instrumentation works by patching libraries (express, pg, http)
// at require-time. That's why it's loaded via `node -r` / `--require`
// rather than being require()'d normally inside server.js.
//
// It sends:
//   - Traces  -> OTel Collector (localhost:4317) -> Jaeger
//   - Metrics -> OTel Collector (localhost:4317) -> Prometheus

const { NodeSDK } = require('@opentelemetry/sdk-node');
const { getNodeAutoInstrumentations } = require('@opentelemetry/auto-instrumentations-node');
const { OTLPTraceExporter } = require('@opentelemetry/exporter-trace-otlp-grpc');
const { OTLPMetricExporter } = require('@opentelemetry/exporter-metrics-otlp-grpc');
const { PeriodicExportingMetricReader } = require('@opentelemetry/sdk-metrics');
const { resourceFromAttributes } = require('@opentelemetry/resources');
const { ATTR_SERVICE_NAME, ATTR_SERVICE_VERSION } = require('@opentelemetry/semantic-conventions');

const OTEL_COLLECTOR_URL = process.env.OTEL_EXPORTER_OTLP_ENDPOINT || 'http://localhost:4317';

const sdk = new NodeSDK({
  resource: resourceFromAttributes({
    [ATTR_SERVICE_NAME]: 'shopnow-backend',
    [ATTR_SERVICE_VERSION]: '1.0.0',
  }),
  traceExporter: new OTLPTraceExporter({
    url: OTEL_COLLECTOR_URL,
  }),
  metricReader: new PeriodicExportingMetricReader({
    exporter: new OTLPMetricExporter({
      url: OTEL_COLLECTOR_URL,
    }),
    exportIntervalMillis: 10000, // push metrics every 10s
  }),
  instrumentations: [
    getNodeAutoInstrumentations({
      // Reduce noise: don't trace filesystem reads (very chatty, low value)
      '@opentelemetry/instrumentation-fs': { enabled: false },
    }),
  ],
});

sdk.start();
console.log('[otel] instrumentation started - service: shopnow-backend, exporting to', OTEL_COLLECTOR_URL);

// Graceful shutdown - flush any pending telemetry before the process exits
process.on('SIGTERM', () => {
  sdk.shutdown()
    .then(() => console.log('[otel] shut down cleanly'))
    .catch((err) => console.error('[otel] error during shutdown', err))
    .finally(() => process.exit(0));
});
