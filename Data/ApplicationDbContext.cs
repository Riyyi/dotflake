using Microsoft.EntityFrameworkCore;

namespace dotflake.Data;

public class ApplicationDbContext : DbContext
{
    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }

    // Add your DbSet properties here
    // Example:
    public DbSet<User> Users { get; set; }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);
        
        // Configure your entity models here
        // Example:
        // modelBuilder.Entity<YourEntity>().HasKey(e => e.Id);
    }
}