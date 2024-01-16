namespace HotelsAPI.Models.Dto;

public class RoomDto
{
    public required int Number { get; set; }
    public int TypeId { get; set; }
    public string? Description { get; set; }
    public required float Price { get; set; }
}
