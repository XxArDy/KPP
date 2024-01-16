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
                DateStart = obj.DateStart,
                DateEnd = obj.DateEnd,
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

    public async Task<List<Invoice>> GetAllInvoices()
    {
        return await _dbContext.Invoices.Include(i => i.Client).Include(i => i.Room).Include(i => i.Room!.Type).ToListAsync();
    }

    public async Task<List<Invoice>> GetAllInvoicesByPhone(string phone)
    {
        return await _dbContext.Invoices
            .Include(i => i.Client)
            .Where(i => i.Client!.Phone!.Contains(phone))
            .Include(i => i.Client)
            .Include(i => i.Room)
            .Include(i => i.Room!.Type)
            .ToListAsync();
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
            invoice.DateStart = obj.DateStart;
            invoice.DateEnd = obj.DateEnd;
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
