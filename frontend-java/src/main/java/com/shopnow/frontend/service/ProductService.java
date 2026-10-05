package com.shopnow.frontend.service;

import com.shopnow.frontend.model.Product;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.Arrays;
import java.util.List;

@Service
public class ProductService {

    private final RestTemplate restTemplate;

    @Value("${backend.api.baseurl}")
    private String backendBaseUrl;

    public ProductService(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public List<Product> getAllProducts(String category, String search) {
        StringBuilder url = new StringBuilder(backendBaseUrl + "/api/products");
        boolean hasQuery = false;

        if (category != null && !category.isEmpty()) {
            url.append(hasQuery ? "&" : "?").append("category=").append(category);
            hasQuery = true;
        }
        if (search != null && !search.isEmpty()) {
            url.append(hasQuery ? "&" : "?").append("search=").append(search);
        }

        Product[] products = restTemplate.getForObject(url.toString(), Product[].class);
        return products != null ? Arrays.asList(products) : List.of();
    }

    public Product getProductById(int id) {
        return restTemplate.getForObject(backendBaseUrl + "/api/products/" + id, Product.class);
    }
}
