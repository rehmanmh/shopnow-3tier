package com.shopnow.frontend.controller;

import com.shopnow.frontend.model.Product;
import com.shopnow.frontend.service.ProductService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class ProductController {

    private final ProductService productService;

    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/")
    public String home(
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String search,
            Model model) {
        model.addAttribute("products", productService.getAllProducts(category, search));
        model.addAttribute("selectedCategory", category == null ? "" : category);
        model.addAttribute("searchTerm", search == null ? "" : search);
        return "index";
    }

    @GetMapping("/product/{id}")
    public String productDetail(@PathVariable int id, Model model) {
        Product product = productService.getProductById(id);
        model.addAttribute("product", product);
        return "product";
    }
}
