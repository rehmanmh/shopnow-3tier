package com.shopnow.frontend.model;

public class Product {
    private int id;
    private String name;
    private String category;
    private String price;
    private String mrp;
    private String rating;
    private int reviews;
    private String image;
    private String description;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getPrice() { return price; }
    public void setPrice(String price) { this.price = price; }

    public String getMrp() { return mrp; }
    public void setMrp(String mrp) { this.mrp = mrp; }

    public String getRating() { return rating; }
    public void setRating(String rating) { this.rating = rating; }

    public int getReviews() { return reviews; }
    public void setReviews(int reviews) { this.reviews = reviews; }

    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
}
