using MediaBrowser.Model.Plugins;

namespace Jellyfin.Plugin.Musian.Configuration;

/// <summary>
/// Plugin configuration.
/// Musian runs entirely in the browser: the mood data and genre zones are
/// stored in app.html, so there is nothing for an administrator to configure.
/// BasePlugin requires a configuration type.
/// </summary>
public class PluginConfiguration : BasePluginConfiguration
{
}
