namespace HotelsAPI.Models;

public class Room
{
    public int Id { get; set; }
    public required int Number { get; set; }
    public int TypeId { get; set; }
    public string? Description { get; set; }
    public required float Price { get; set; }

    public RoomType? Type { get; set; }
}
