using System;
using System.Collections.Generic;
using Jellyfin.Plugin.Musian.Configuration;
using MediaBrowser.Common.Configuration;
using MediaBrowser.Common.Plugins;
using MediaBrowser.Model.Plugins;
using MediaBrowser.Model.Serialization;

namespace Jellyfin.Plugin.Musian;

/// <summary>
/// Musian: a mood wheel player for a Jellyfin music library.
/// </summary>
public class Plugin : BasePlugin<PluginConfiguration>, IHasWebPages
{
    /// <summary>
    /// Initializes a new instance of the <see cref="Plugin"/> class.
    /// </summary>
    public Plugin(IApplicationPaths applicationPaths, IXmlSerializer xmlSerializer)
        : base(applicationPaths, xmlSerializer)
    {
        Instance = this;
    }

    /// <summary>Gets the singleton instance.</summary>
    public static Plugin? Instance { get; private set; }

    /// <summary>
    /// Gets the plugin id. Jellyfin uses it to identify the plugin in the
    /// repository and in saved configuration, so it must not change.
    /// </summary>
    public override Guid Id => Guid.Parse("6c8a80b7-3e2f-4d5a-9b1c-f7e8d9a0b2c3");

    /// <inheritdoc />
    public override string Name => "Musian";

    /// <inheritdoc />
    public override string Description =>
        "Your music, without the scrolling. A mood music player for your Jellyfin server.";

    /// <inheritdoc />
    public IEnumerable<PluginPageInfo> GetPages()
    {
        var ns = GetType().Namespace;
        return
        [
            new PluginPageInfo
            {
                Name = "musian",
                DisplayName = "Musian",
                EmbeddedResourcePath = $"{ns}.Configuration.moodPicker.html",
                EnableInMainMenu = true,
                MenuIcon = "music_note",
                MenuSection = "",
            },
        ];
    }
}
