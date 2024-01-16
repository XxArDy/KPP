namespace HotelsAPI.Models;

public class Invoice
{
    public int Id { get; set; }
    public required int RoomId { get; set; }
    public required int ClientId { get; set; }
    public DateTime DateStart { get; set; }
    public DateTime DateEnd { get; set; }
    public float Amount { get; set; }

    public Room? Room { get; set; }
    public Client? Client { get; set; }
}
