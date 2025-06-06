﻿using System.ComponentModel.DataAnnotations;

namespace ProductWebApp.Models;

public class Product
{
    public int Id { get; set; }
    [Required]
    public required string Name { get; set; }
    public string? Description { get; set; }
    public string? Category { get; set; }
    public decimal Price { get; set; }
    public int Quantity { get; set; }
}