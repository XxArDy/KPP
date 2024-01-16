using HotelsAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace HotelsAPI.Data;

#pragma warning disable CS1591
public class ApplicationDbContext : DbContext
{
    public DbSet<RoomType> RoomTypes { get; set; }
    public DbSet<Room> Rooms { get; set; }
    public DbSet<Client> Clients { get; set; }
    public DbSet<Invoice> Invoices { get; set; }

    public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
        : base(options)
    {
    }
}
#pragma warning restore CS1591
