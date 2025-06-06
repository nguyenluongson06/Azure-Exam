using Microsoft.EntityFrameworkCore;
using ProductWebApp.Models;

namespace ProductWebApp.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : DbContext(options)
{
   public DbSet<Product> Products { get; set; }
}