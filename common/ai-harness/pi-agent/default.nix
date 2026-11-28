{
  inputs,
  pkgs,
  config,
  ...
}:
{
  home.file = {
    "${config.programs.pi-coding-agent.configDir}/zentui.json".source = ./agent/zentui.json;
    "${config.programs.pi-coding-agent.configDir}/clipboard.json".text = builtins.toJSON {
      enabled = true;
    };
    "${config.programs.pi-coding-agent.configDir}/extensions/rtk.ts".source =
      "${pkgs.rtk.src}/hooks/pi/rtk.ts";
  };

  programs.pi-coding-agent = {
    enable = true;
    package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.pi;
    extraPackages = [
      pkgs.nodejs
      pkgs.rtk
    ];
    settings = {
      defaultProvider = "antigravity";
      defaultModel = "gemini-4-neon";
      defaultThinkingLevel = "high";
      defaultTools = [ "+codemode" ];
      tuiMode = "fullscreen";
      packages = [
        "npm:@narumitw/pi-tool"
        "npm:pi-context-view"
        "npm:pi-zentui"
        "npm:pi-antigravity"

        {
          source = "git:github.com/hh9dj/pi-agent-extensions";
          extensions = [
            "extensions/plan-mode/index.ts"
            "extensions/skeptic-agent/index.ts"
            "extensions/deepseek-tier/index.ts"
          ];
        }
      ];
      theme = "light";
    };
    keybindings = {
      "tui.select.up" = [
        "up"
        "ctrl+p"
      ];
      "tui.select.down" = [
        "down"
        "ctrl+n"
      ];
      "tui.editor.historyNext" = [
        "down"
        "ctrl+n"
      ];
      "tui.editor.historyPrevious" = [
        "up"
        "ctrl+p"
      ];
      "app.editor.external" = "ctrl+e";
      "app.session.togglePath" = [ ];
      "app.session.toggleNamedFilter" = [ ];
      "app.session.resume" = "ctrl+r";
      "app.model.cycleForward" = [ ];
      "app.model.cycleBackward" = [ ];
      "app.thinking.cycle" = "ctrl+t";
      "app.thinking.toggle" = "ctrl+shift+t";
      "tui.input.tab" = [
        "tab"
        "ctrl+y"
      ];
      "tui.input.newLine" = "shift+enter";
      "tui.altScreen.halfPageUp" = "ctrl+alt+u";
      "tui.altScreen.halfPageDown" = "ctrl+alt+d";
      "tui.altScreen.bottom" = "ctrl+g";
    };
  };
}
