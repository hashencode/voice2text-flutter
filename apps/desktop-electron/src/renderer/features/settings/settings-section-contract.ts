export const SETTINGS_SECTION_IDS = {
  general: "settings-general",
  recording: "settings-recording",
  "local-models": "settings-local-models",
  "cloud-models": "settings-cloud-models",
} as const;

export type SettingsSection = keyof typeof SETTINGS_SECTION_IDS;

export function isSettingsSection(
  value: string | undefined,
): value is SettingsSection {
  return value !== undefined && value in SETTINGS_SECTION_IDS;
}
