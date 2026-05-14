enum BnaComponentStatus { migrated, planned }

class BnaComponentDefinition {
  const BnaComponentDefinition({
    required this.name,
    required this.slug,
    required this.description,
    required this.status,
  });

  final String name;
  final String slug;
  final String description;
  final BnaComponentStatus status;

  String get docsUrl => 'https://ui.ahmedbna.com/docs/components/$slug';
}

const List<BnaComponentDefinition> bnaComponents = <BnaComponentDefinition>[
  BnaComponentDefinition(
    name: 'Accordion',
    slug: 'accordion',
    description: 'Collapsible content sections.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Action Sheet',
    slug: 'action-sheet',
    description: 'Bottom action sheet patterns.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Alert',
    slug: 'alert',
    description: 'Inline alert messaging.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Alert Dialog',
    slug: 'alert-dialog',
    description: 'Confirmation and modal alerts.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Audio Player',
    slug: 'audio-player',
    description: 'Playback controls and progress UI.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Audio Recorder',
    slug: 'audio-recorder',
    description: 'Recording interface and state controls.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Audio Waveform',
    slug: 'audio-waveform',
    description: 'Waveform visualizations for audio.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Avatar',
    slug: 'avatar',
    description: 'Profile images and status chips.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'AvoidKeyboard',
    slug: 'avoid-keyboard',
    description: 'Keyboard-safe layout helpers.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Badge',
    slug: 'badge',
    description: 'Small labels and state indicators.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'BottomSheet',
    slug: 'bottom-sheet',
    description: 'Sheet presentation and gestures.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Button',
    slug: 'button',
    description:
        'A versatile button component with multiple variants, sizes, and interactive animations.',
    status: BnaComponentStatus.migrated,
  ),
  BnaComponentDefinition(
    name: 'Camera',
    slug: 'camera',
    description: 'Capture and live preview controls.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Camera Preview',
    slug: 'camera-preview',
    description: 'Media preview surfaces.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Card',
    slug: 'card',
    description: 'Content containers and grouped panels.',
    status: BnaComponentStatus.migrated,
  ),
  BnaComponentDefinition(
    name: 'Carousel',
    slug: 'carousel',
    description: 'Scrollable card and media rails.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Checkbox',
    slug: 'checkbox',
    description: 'Boolean selection controls.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Collapsible',
    slug: 'collapsible',
    description: 'Simple expand and collapse patterns.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Color Picker',
    slug: 'color-picker',
    description: 'Color selection UI.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Combobox',
    slug: 'combobox',
    description: 'Searchable option selection.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Date Picker',
    slug: 'date-picker',
    description: 'Date and range picking surfaces.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'File Picker',
    slug: 'file-picker',
    description: 'File import flows.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Gallery',
    slug: 'gallery',
    description: 'Image collection browsing.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Hello Wave',
    slug: 'hello-wave',
    description: 'Animated greeting affordance.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Icon',
    slug: 'icon',
    description: 'Shared icon wrapper and sizing.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Image',
    slug: 'image',
    description: 'Image display helpers.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Input',
    slug: 'input',
    description:
        'A styled text input component with label, validation, icons, and grouped layouts.',
    status: BnaComponentStatus.migrated,
  ),
  BnaComponentDefinition(
    name: 'Input OTP',
    slug: 'input-otp',
    description: 'One-time password entry.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Link',
    slug: 'link',
    description: 'Inline navigation and actions.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'MediaPicker',
    slug: 'media-picker',
    description: 'Media choosing and upload flow.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Mode Toggle',
    slug: 'mode-toggle',
    description: 'Light and dark theme toggle.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Onboarding',
    slug: 'onboarding',
    description: 'Multi-step intro screens.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'ParallaxScrollView',
    slug: 'parallax-scrollview',
    description: 'Parallax header scrolling.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Picker',
    slug: 'picker',
    description: 'Single and multi-select pickers.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Popover',
    slug: 'popover',
    description: 'Floating contextual panels.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Progress',
    slug: 'progress',
    description: 'Determinate progress indicators.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Radio',
    slug: 'radio',
    description: 'Single-choice selection UI.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'ScrollView',
    slug: 'scroll-view',
    description: 'Scrollable content helpers.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'SearchBar',
    slug: 'searchbar',
    description: 'Search field patterns.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Separator',
    slug: 'separator',
    description: 'Visual dividers.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Share',
    slug: 'share',
    description: 'Share actions and payload controls.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Sheet',
    slug: 'sheet',
    description: 'Bottom and modal sheet layouts.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Skeleton',
    slug: 'skeleton',
    description: 'Loading placeholders.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Spinner',
    slug: 'spinner',
    description: 'Loading indicators and overlays.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Switch',
    slug: 'switch',
    description: 'Binary toggle control.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Table',
    slug: 'table',
    description: 'Tabular layout patterns.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Tabs',
    slug: 'tabs',
    description: 'Segmented and tabbed navigation.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Text',
    slug: 'text',
    description: 'Typography primitives.',
    status: BnaComponentStatus.migrated,
  ),
  BnaComponentDefinition(
    name: 'Toast',
    slug: 'toast',
    description: 'Transient notification banners.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Toggle',
    slug: 'toggle',
    description: 'Selectable toggle controls.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'Video',
    slug: 'video',
    description: 'Video player surfaces.',
    status: BnaComponentStatus.planned,
  ),
  BnaComponentDefinition(
    name: 'View',
    slug: 'view',
    description: 'Base layout wrapper.',
    status: BnaComponentStatus.planned,
  ),
];

BnaComponentDefinition? findBnaComponent(String slug) {
  for (final BnaComponentDefinition component in bnaComponents) {
    if (component.slug == slug) {
      return component;
    }
  }
  return null;
}
