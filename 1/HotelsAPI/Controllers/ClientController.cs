using HotelsAPI.Models;
using HotelsAPI.Models.Dto;
using HotelsAPI.Services;
using Microsoft.AspNetCore.Mvc;

namespace HotelsAPI.Controllers;

/// <summary>
/// API Controller for managing clients.
/// </summary>
[ApiController]
[Route("api/[controller]")]
public class ClientController : ControllerBase
{
	private readonly IClientService _clientService;

	/// <summary>
	/// Initializes a new instance of the <see cref="ClientController"/> class.
	/// </summary>
	/// <param name="clientService">The client service.</param>
	public ClientController(IClientService clientService)
	{
		_clientService = clientService;
	}

	/// <summary>
	/// Gets a list of all clients.
	/// </summary>
	/// <returns>List of clients</returns>
	/// <response code="200">Returns list of clients</response>
	[HttpGet]
	[ProducesResponseType(StatusCodes.Status200OK)]
	public async Task<IActionResult> GetAllClients()
	{
		var clients = await _clientService.GetAllClients();
		return Ok(clients);
	}

	/// <summary>
	/// Gets client details by ID.
	/// </summary>
	/// <param name="id">The client ID</param>
	/// <returns>Client details</returns>
	/// <response code="200">Returns client details</response>
	/// <response code="404">If the client is null</response>
	[HttpGet("{id}")]
	[ProducesResponseType(StatusCodes.Status200OK)]
	[ProducesResponseType(StatusCodes.Status404NotFound)]
	public async Task<IActionResult> GetClientById(int id)
	{
		var client = await _clientService.GetClientByID(id);
		if (client == null)
		{
			return NotFound();
		}
		return Ok(client);
	}

	/// <summary>
	/// Adds a new client.
	/// </summary>
	/// <param name="clientDto">The client data</param>
	/// <returns>The newly created client</returns>
	/// <remarks>
	/// Sample request:
	///
	///     POST /Client
	///     {
	///        "firstName": "Arthur",
	///        "lastName": "Nitcevitch",
	///        "phone": "+380999999999"
	///     }
	///
	/// </remarks>
	/// <response code="201">Returns the newly created client</response>
	/// <response code="409">If the client have conflict</response>
	[HttpPost]
	[ProducesResponseType(StatusCodes.Status201Created)]
	[ProducesResponseType(StatusCodes.Status409Conflict)]
	public async Task<IActionResult> AddClient([FromBody] ClientDto clientDto)
	{
		var addedClient = await _clientService.AddClient(clientDto);
		return CreatedAtAction(nameof(GetClientById), new { id = addedClient.Id }, addedClient);
	}

	/// <summary>
	/// Updates an existing client.
	/// </summary>
	/// <param name="id">The client ID</param>
	/// <param name="clientDto">The updated client data</param>
	/// <returns>The updated client</returns>
	/// <remarks>
	/// Sample request:
	///
	///     PUT /Client/{id}
	///     {
	///        "firstName": "Arthur",
	///        "lastName": "Nitcevitch",
	///        "phone": "+380999999999"
	///     }
	///
	/// </remarks>
	/// <response code="200">Returns the updated client</response>
	/// <response code="404">If the client is null</response>
	[HttpPut("{id}")]
	[ProducesResponseType(StatusCodes.Status200OK)]
	[ProducesResponseType(StatusCodes.Status404NotFound)]
	public async Task<IActionResult> UpdateClient(int id, [FromBody] ClientDto clientDto)
	{
		var updatedClient = await _clientService.UpdateClient(id, clientDto);
		if (updatedClient == null)
		{
			return NotFound();
		}
		return Ok(updatedClient);
	}

	/// <summary>
	/// Deletes a client by ID.
	/// </summary>
	/// <param name="id">The client ID</param>
	/// <returns>No content if the client is deleted, NotFound if the client is not found</returns>
	/// <response code="204">Returns the succeed deleted status</response>
	/// <response code="404">If the client is null</response>
	[HttpDelete("{id}")]
	[ProducesResponseType(StatusCodes.Status204NoContent)]
	[ProducesResponseType(StatusCodes.Status404NotFound)]
	public async Task<IActionResult> DeleteClientById(int id)
	{
		var result = await _clientService.DeleteClientByID(id);
		if (!result)
		{
			return NotFound();
		}
		return NoContent();
	}
}
