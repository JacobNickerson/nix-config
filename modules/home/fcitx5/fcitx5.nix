{ config, pkgs, ... }:

{

  i18n.inputMethod.enable = true;
  i18n.inputMethod.type = "fcitx5";
  i18n.inputMethod.fcitx5 = {
    addons = [
      pkgs.qt6Packages.fcitx5-chinese-addons
    ];
    settings = {
      inputMethod = {
        GroupOrder."0" = "Default";
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "keyboard-us";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "pinyin";
      };
      addons.notifications.sections.HiddenNotifications = {
        "0" = "wayland-diagnose-other";
      };
      addons.pinyin.globalSection = {
        CloudPinyinEnabled = "False";
        FirstRun = "False";
      };
      globalOptions = {
        Hotkey = {
          EnumerateWithTriggerKeys = "True";
          EnumerateSkipFirst = "False";
          ModifierOnlyKeyTimeout = 250;
        };
        "Hotkey/TriggerKeys" = {
          "0" = "Super+space";
          "1" = "Zenkaku_Hankaku";
          "2" = "Hangul";
        };
        "Hotkey/ActivateKeys" = {
          "0" = "Hangul_Hanja";
        };
        "Hotkey/DeactivateKeys" = {
          "0" = "Hangul_Romaja";
        };
        "Hotkey/AltTriggerKeys" = {
          "0" = "Shift_L";
        };
        "Hotkey/EnumeratedGroupForwardKeys" = {
          "0" = "Super+space";
        };
        "Hotkey/EnumeratedGroupBackwardKeys" = {
          "0" = "Shift+Super+space";
        };
        "Hotkey/PrevPage" = {
          "0" = "Up";
        };
        "Hotkey/NextPage" = {
          "0" = "Up";
        };
        "Hotkey/PrevCandidate" = {
          "0" = "Shift+Tab";
        };
        "Hotkey/NextCandidate" = {
          "0" = "Tab";
        };
        "Hotkey/TogglePreedit" = {
          "0" = "Control+Alt+P";
        };

        Behavior = {
          ActiveByDefault = "False";
          resetStateWhenFocusIn = "No";
          ShareInputState = "No";
          PreeditEnabledByDefault = "True";
          ShowInputMethodInformation = "True";
          showInputMethodInformationWhenFocusIn = "False";
          CompactInputMethodInformation = "True";
          ShowFirstInputMethodInformation = "True";
          DefaultPageSize = 5;
          OverrideXkbOption = "False";
          PreloadInputMethod = "True";
          AllowInputMethodForPassword = "True";
          ShowPreeditForPassword = "False";
          AutoSavePeriod = 30;
        };
      };
    };
  };
}
