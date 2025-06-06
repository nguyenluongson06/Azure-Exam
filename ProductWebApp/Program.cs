using Microsoft.EntityFrameworkCore;
using ProductWebApp.Data;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllersWithViews();

//get connection string from appsettings
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");
builder.Services.AddDbContext<AppDbContext>(options => options.UseSqlServer(connectionString));

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

Console.WriteLine("Creating scope...");
try
{
    using var scope = app.Services.CreateScope();
    Console.WriteLine("Scope created.");
    var db = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    Console.WriteLine("Got AppDbContext.");
    db.Database.EnsureCreated();
    Console.WriteLine("Database created.");
}
catch (Exception ex)
{
    Console.WriteLine($"❌ Error creating database: {ex.Message}");
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Products}/{action=Index}/{id?}");

app.Run();