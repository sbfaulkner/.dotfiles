#!/usr/bin/env python3

import asyncio
import iterm2

DARK_THEME = "Dark Background"
LIGHT_THEME = "Light Background"
PROFILES = ["Default"]

async def set_theme(connection, effective_theme):
    # Themes have space-delimited attributes, one of which will be light or dark.
    parts = effective_theme.split(" ")
    if "dark" in parts:
        new_theme = DARK_THEME
    else:
        new_theme = LIGHT_THEME
    # Get the theme
    preset = await iterm2.ColorPreset.async_get(connection, new_theme)

    # Update the list of all profiles and iterate over them.
    profiles = await iterm2.PartialProfile.async_query(connection)
    for partial in profiles:
        if partial.name in PROFILES:
            # Fetch the full profile and then set the color preset in it.
            profile = await partial.async_get_full_profile()
            await profile.async_set_color_preset(preset)


async def main(connection):
    # Set theme at start
    app = await iterm2.async_get_app(connection)
    effective_theme = await app.async_get_variable("effectiveTheme")
    await set_theme(connection, effective_theme)

    # Monitor changes to system theme
    async with iterm2.VariableMonitor(connection, iterm2.VariableScopes.APP, "effectiveTheme", None) as mon:
        while True:
            # Block until effective_theme changes
            effective_theme = await mon.async_get()

            await set_theme(connection, effective_theme)

iterm2.run_forever(main)
