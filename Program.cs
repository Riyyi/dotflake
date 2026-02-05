using dotflake.Data;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring OpenAPI at https://aka.ms/aspnet/openapi
builder.Services.AddOpenApi();

// Databases
var postgresConnectionString = builder.Configuration.GetConnectionString("PostgresDb") ??
    throw new InvalidOperationException("Connection string 'PostgresDb' not found.");

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(postgresConnectionString));

var app = builder.Build();

using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();

    // Run migrations at startup
    await db.Database.MigrateAsync();

    // Seed data
    await SeedData.Seed(db);
}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

app.MapGet("/users", (ApplicationDbContext db) =>
{
    return db.Users.ToList();
})
.WithName("GetUsers");

app.Run();