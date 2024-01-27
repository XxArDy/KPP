using HotelsAPI.Data;
using HotelsAPI.Models;
using HotelsAPI.Models.Dto;
using Microsoft.EntityFrameworkCore;

namespace HotelsAPI.Services;

public class InvoiceService : IInvoiceService
{
    private readonly ApplicationDbContext _dbContext;

    public InvoiceService(ApplicationDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public async Task<Invoice> AddInvoice(InvoiceDto obj)
    {
        if (await IsRoomAvailable(obj.RoomId, obj.DateStart, obj.DateEnd))
        {
            var invoice = new Invoice
            {
                RoomId = obj.RoomId,
                ClientId = obj.ClientId,
                DateStart = DateTime.SpecifyKind(obj.DateStart, DateTimeKind.Utc),
                DateEnd = DateTime.SpecifyKind(obj.DateEnd, DateTimeKind.Utc),
                Amount = await CalculateAmount(obj.RoomId, obj.DateStart, obj.DateEnd)
            };

            _dbContext.Invoices.Add(invoice);
            await _dbContext.SaveChangesAsync();

            return invoice;
        }
        else
        {
            throw new InvalidOperationException("Room is not available for the specified date range.");
        }
    }

    public async Task<bool> CheckIsRoomAvailable(int roomId, DateTime dateStart, DateTime dateEnd)
    {
        return await IsRoomAvailable(roomId, dateStart, dateEnd);
    }

    public async Task<bool> DeleteInvoiceByID(int id)
    {
        var invoice = await _dbContext.Invoices.FindAsync(id);

        if (invoice == null)
        {
            return false;
        }

        _dbContext.Invoices.Remove(invoice);
        await _dbContext.SaveChangesAsync();

        return true;
    }

    public async Task<List<Invoice>> GetAllInvoices(string? searchInput, SortingValue? sortingInput)
    {
        List<Invoice> query = await _dbContext.Invoices.Include(i => i.Client).Include(i => i.Room).Include(i => i.Room!.Type).ToListAsync();

        if (!string.IsNullOrEmpty(searchInput))
        {
            int.TryParse(searchInput, out var num);
            query = query.Where(invoice =>
                    invoice.Client!.FirstName!.Contains(searchInput, StringComparison.OrdinalIgnoreCase) ||
                    invoice.Client!.LastName!.Contains(searchInput, StringComparison.OrdinalIgnoreCase) ||
                    invoice.Client!.Phone!.Contains(searchInput, StringComparison.OrdinalIgnoreCase) ||
                    invoice.Room!.Number == num ||
                    invoice.Room!.Type!.Name!.Contains(searchInput, StringComparison.OrdinalIgnoreCase)).ToList();
        }

        if (sortingInput != null)
        {
            switch (sortingInput)
            {
                case SortingValue.asc:
                    query = query.OrderBy(invoice => invoice.Id).ToList();
                    break;
                case SortingValue.desc:
                    query = query.OrderByDescending(invoice => invoice.Id).ToList();
                    break;
            }
        }

        return query;
    }

    public async Task<Invoice?> GetInvoiceByID(int id)
    {
        return await _dbContext.Invoices.Include(i => i.Client).Include(i => i.Room).Include(i => i.Room!.Type).FirstOrDefaultAsync(i => i.Id == id);
    }

    public async Task<Invoice?> UpdateInvoice(int id, InvoiceDto obj)
    {
        if (await IsRoomAvailable(obj.RoomId, obj.DateStart, obj.DateEnd, id))
        {
            var invoice = await _dbContext.Invoices.FindAsync(id);

            if (invoice == null)
            {
                return null;
            }

            invoice.RoomId = obj.RoomId;
            invoice.ClientId = obj.ClientId;
            invoice.DateStart = DateTime.SpecifyKind(obj.DateStart, DateTimeKind.Utc);
            invoice.DateEnd = DateTime.SpecifyKind(obj.DateEnd, DateTimeKind.Utc);
            invoice.Amount = await CalculateAmount(obj.RoomId, obj.DateStart, obj.DateEnd);

            await _dbContext.SaveChangesAsync();

            return invoice;
        }
        else
        {
            throw new InvalidOperationException("Room is not available for the specified date range.");
        }
    }

    public async Task<bool> IsRoomAvailable(int roomId, DateTime dateStart, DateTime dateEnd, int? currentInvoiceId = null)
    {
        dateStart = DateTime.SpecifyKind(dateStart, DateTimeKind.Utc);
        dateEnd = DateTime.SpecifyKind(dateEnd, DateTimeKind.Utc);

        var overlappingInvoice = await _dbContext.Invoices
            .Where(i => i.RoomId == roomId && i.Id != currentInvoiceId &&
                        ((dateStart >= i.DateStart && dateStart < i.DateEnd) ||
                        (dateEnd > i.DateStart && dateEnd <= i.DateEnd) ||
                        (dateStart <= i.DateStart && dateEnd >= i.DateEnd)))
            .FirstOrDefaultAsync();

        return overlappingInvoice == null;
    }

    public async Task<float> CalculateAmount(int roomId, DateTime dateStart, DateTime dateEnd)
    {
        var room = await _dbContext.Rooms.FindAsync(roomId);

        if (room == null)
        {
            throw new InvalidOperationException("Room not found.");
        }

        var duration = (float)(dateEnd - dateStart).TotalDays;

        var amount = room.Price * duration;

        return amount;
    }

}
