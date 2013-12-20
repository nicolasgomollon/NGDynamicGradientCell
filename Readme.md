# NGDynamicGradientCell

<img alt="NGDynamicGradientCell Screenshot" width="320" height="568" src="http://f.cl.ly/items/0O3C2g1Q2M0Q372R2M2W/NGDynamicGradientCell_Screenshot.png" />


## Getting Started

Run the following commands to get started:

    $ git clone --recursive https://github.com/nicolasgomollon/NGDynamicGradientCell.git
    $ cd NGDynamicGradientCell
    $ rake setup


## DIY Instructions

1. The `NGDynamicGradientCell` repo depends heavily on [`SSToolkit`](https://github.com/soffes/sstoolkit), so you need to follow the instructions for [Adding SSToolkit to Your Project](http://sstoolk.it/#getting-started).

2. Add this line to your `Prefix.pch` file (between `#ifdef __OBJC__` and `#endif`:
```objective-c
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
```

3. Drag `NGDynamicGradientCell.h`, `NGDynamicGradientCell.m`, and the `Images` folder to your project.

4. Take a look at `MasterViewController.m` for an example of the things that should be included in your project's `UITableViewController`.

5. That's all.


## Important Note

`NGDynamicGradientCell` uses ARC, and does not support Storyboards.

If your app does not use ARC, it is still possible to compile only certain files with ARC by adding a flag to the `.m` file(s) that require it:

1. Select your main Xcode project from the sidebar in Xcode.

2. Select the _Build Phases_ tab.

3. Under the _Compile Sources_ group, double-click on the file name.

4. Add `-fobjc-arc` to the popup window.