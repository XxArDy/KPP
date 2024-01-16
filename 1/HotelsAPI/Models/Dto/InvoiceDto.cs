namespace HotelsAPI.Models.Dto;

public class InvoiceDto
{
    public required int RoomId { get; set; }
    public required int ClientId { get; set; }
    public DateTime DateStart { get; set; }
    public DateTime DateEnd { get; set; }
}
