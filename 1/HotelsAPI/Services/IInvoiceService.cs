using HotelsAPI.Models;
using HotelsAPI.Models.Dto;

namespace HotelsAPI.Services;

public interface IInvoiceService
{
    Task<List<Invoice>> GetAllInvoicesByPhone(string phone);

    Task<List<Invoice>> GetAllInvoices();

    Task<Invoice?> GetInvoiceByID(int id);

    Task<Invoice> AddInvoice(InvoiceDto obj);

    Task<Invoice?> UpdateInvoice(int id, InvoiceDto obj);

    Task<bool> DeleteInvoiceByID(int id);

    Task<float> CalculateAmount(int roomId, DateTime dateStart, DateTime dateEnd);

    Task<bool> IsRoomAvailable(int roomId, DateTime dateStart, DateTime dateEnd, int? currentInvoiceId = null);
}
