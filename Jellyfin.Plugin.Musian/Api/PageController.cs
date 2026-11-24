using System.IO;
using System.Reflection;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Jellyfin.Plugin.Musian.Api;

/// <summary>
/// Serves the standalone Musian page.
/// </summary>
[ApiController]
[Route("Musian")]
public class PageController : ControllerBase
{
    private static string GetResource(string name)
    {
        var ns = typeof(Plugin).Namespace;
        var resourceName = $"{ns}.Configuration.{name}";
        using var stream = Assembly.GetExecutingAssembly()
            .GetManifestResourceStream(resourceName)
            ?? throw new FileNotFoundException($"Resource not found: {resourceName}");
        using var reader = new StreamReader(stream);
        return reader.ReadToEnd();
    }

    /// <summary>
    /// Returns the app page at /Musian/app.
    /// </summary>
    [HttpGet("app")]
    [Produces("text/html")]
    [ProducesResponseType(StatusCodes.Status200OK)]
    public ContentResult GetApp()
        => Content(GetResource("app.html"), "text/html");
}
