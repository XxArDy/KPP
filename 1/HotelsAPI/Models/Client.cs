namespace HotelsAPI.Models;

public class Client
{
    public int Id { get; set; }
    public required string? FirstName { get; set; }
    public required string? LastName { get; set; }
    public required string? Phone { get; set; }
}
