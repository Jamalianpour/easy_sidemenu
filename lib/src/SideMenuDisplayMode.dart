enum SideMenuDisplayMode {
  /// Let the [Sidemenu] decide what display mode should be used
  /// based on the width. This is used by default on [Sidemenu].
  /// In Auto mode, the [Sidemenu] adapts between [compact],
  ///  and then [open] as the window gets wider.
  auto,

  /// The pane is expanded and positioned to the left of the content.
  ///
  /// Use open mode when:
  ///   * You have 5-10 equally important top-level navigation categories.
  ///   * You want navigation categories to be very prominent, with less
  ///     space for other app content.
  open,

  /// The [Sidemenu] shows only icons until opened and is positioned to the left
  /// of the content.
  compact
}
