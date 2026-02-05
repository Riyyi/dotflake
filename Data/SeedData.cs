namespace dotflake.Data;

public static class SeedData
{
    public static async Task Seed(ApplicationDbContext db)
    {
        if (!db.Users.Any()) {
            var user = new User {
                Name = "anon",
                Password = "pass",
            };
            db.Users.Add(user);
        }

        await db.SaveChangesAsync();
    }
}