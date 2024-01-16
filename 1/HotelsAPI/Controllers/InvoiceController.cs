using HotelsAPI.Models.Dto;
using HotelsAPI.Services;
using Microsoft.AspNetCore.Mvc;

namespace HotelsAPI.Controllers;

/// <summary>
/// API Controller for managing invoices.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class InvoiceController : ControllerBase
{
	private readonly IInvoiceService _invoiceService;

	/// <summary>
	/// Initializes a new instance of the <see cref="InvoiceController"/> class.
	/// </summary>
	/// <param name="invoiceService">The invoice service.</param>
	public InvoiceController(IInvoiceService invoiceService)
	{
		_invoiceService = invoiceService;
	}

	/// <summary>
	/// Adds a new invoice.
	/// </summary>
	/// <param name="invoiceDto">The invoice data.</param>
	/// <returns>The newly created invoice.</returns>
	/// <remarks>
	/// Sample request:
	///
	///     POST /Invoice
	///     {
	///        "roomId": 1,
	///        "clientId": 1,
	///        "dateStart": "2024-01-20T12:00:00",
	///        "dateEnd": "2024-01-25T12:00:00"
	///     }
	///
	/// </remarks>
	/// <response code="201">Returns the newly created invoice</response>
	/// <response code="400">If the room is not available for the specified date range</response>
	[HttpPost]
	[ProducesResponseType(StatusCodes.Status201Created)]
	[ProducesResponseType(StatusCodes.Status400BadRequest)]
	public async Task<IActionResult> AddInvoice([FromBody] InvoiceDto invoiceDto)
	{
		try
		{
			var addedInvoice = await _invoiceService.AddInvoice(invoiceDto);
			return CreatedAtAction(nameof(GetInvoiceById), new { id = addedInvoice.Id }, addedInvoice);
		}
		catch (InvalidOperationException ex)
		{
			return BadRequest(ex.Message);
		}
	}

	/// <summary>
	/// Deletes an invoice by ID.
	/// </summary>
	/// <param name="id">The invoice ID.</param>
	/// <returns>No content if the invoice is deleted, NotFound if the invoice is not found.</returns>
	[HttpDelete("{id}")]
	[ProducesResponseType(StatusCodes.Status204NoContent)]
	[ProducesResponseType(StatusCodes.Status404NotFound)]
	public async Task<IActionResult> DeleteInvoiceById(int id)
	{
		var result = await _invoiceService.DeleteInvoiceByID(id);
		if (!result)
		{
			return NotFound();
		}
		return NoContent();
	}

	/// <summary>
	/// Gets a list of all invoices.
	/// </summary>
	/// <returns>List of invoices.</returns>
	[HttpGet]
	[ProducesResponseType(StatusCodes.Status200OK)]
	public async Task<IActionResult> GetAllInvoices()
	{
		var invoices = await _invoiceService.GetAllInvoices();
		return Ok(invoices);
	}

	/// <summary>
	/// Gets invoices by client phone.
	/// </summary>
	/// <param name="phone">The client phone number.</param>
	/// <returns>List of invoices for the specified client.</returns>
	[HttpGet("ByPhone/{phone}")]
	[ProducesResponseType(StatusCodes.Status200OK)]
	public async Task<IActionResult> GetAllInvoicesByPhone(string phone)
	{
		var invoices = await _invoiceService.GetAllInvoicesByPhone(phone);
		return Ok(invoices);
	}

	/// <summary>
	/// Updates an existing invoice.
	/// </summary>
	/// <param name="id">The invoice ID.</param>
	/// <param name="invoiceDto">The updated invoice data.</param>
	/// <returns>The updated invoice.</returns>
	/// <remarks>
	/// Sample request:
	///
	///     PUT /Invoice/{id}
	///     {
	///        "roomId": 1,
	///        "clientId": 1,
	///        "dateStart": "2024-01-20T12:00:00",
	///        "dateEnd": "2024-01-25T12:00:00"
	///     }
	///
	/// </remarks>
	/// <response code="200">Returns the updated invoice</response>
	/// <response code="400">If the room is not available for the specified date range</response>
	/// <response code="404">If the invoice is null</response>
	[HttpPut("{id}")]
	[ProducesResponseType(StatusCodes.Status200OK)]
	[ProducesResponseType(StatusCodes.Status400BadRequest)]
	[ProducesResponseType(StatusCodes.Status404NotFound)]
	public async Task<IActionResult> UpdateInvoice(int id, [FromBody] InvoiceDto invoiceDto)
	{
		try
		{
			var updatedInvoice = await _invoiceService.UpdateInvoice(id, invoiceDto);
			if (updatedInvoice == null)
			{
				return NotFound();
			}
			return Ok(updatedInvoice);
		}
		catch (InvalidOperationException ex)
		{
			return BadRequest(ex.Message);
		}
	}

	/// <summary>
	/// Gets an invoice by ID.
	/// </summary>
	/// <param name="id">The invoice ID.</param>
	/// <returns>The invoice details.</returns>
	/// <response code="200">Returns the invoice details</response>
	/// <response code="404">If the invoice is null</response>
	[HttpGet("{id}")]
	[ProducesResponseType(StatusCodes.Status200OK)]
	[ProducesResponseType(StatusCodes.Status404NotFound)]
	public async Task<IActionResult> GetInvoiceById(int id)
	{
		var invoice = await _invoiceService.GetInvoiceByID(id);
		if (invoice == null)
		{
			return NotFound();
		}
		return Ok(invoice);
	}

	/// <summary>
	/// Checks if a room is available for the specified date range.
	/// </summary>
	/// <param name="roomId">The room ID.</param>
	/// <param name="dateStart">The start date of the reservation.</param>
	/// <param name="dateEnd">The end date of the reservation.</param>
	/// <returns>True if the room is available, false otherwise.</returns>
	[HttpGet("CheckAvailability")]
	[ProducesResponseType(StatusCodes.Status200OK)]
	public async Task<IActionResult> CheckRoomAvailability(int roomId, DateTime dateStart, DateTime dateEnd)
	{
		var isAvailable = await _invoiceService.IsRoomAvailable(roomId, dateStart, dateEnd);
		return Ok(isAvailable);
	}
}
