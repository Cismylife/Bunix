# mkdrive

Tool used for creating VFS ramdisk images that are used with the Hilix kernel.

### Building an Initrd Image

To build an initrd image for Hilix is a simple task.  Doing such allows you to add custom
applications and binaries and data to Hilix's VFS used during booting.  The ```hdd``` folder
will be used as the root directory when building the image.

To build an image takes just a few steps, and is easily done.  First off in this directory run:
```make``` to build the mkinitrd tool.

Once that is completed the run:
```make bin``` to build to Hilix application binaries (init, etc).

Lastly run:
```make initrd``` to compile the image and copy it over to the build directory.

One all the previously mentioned steps have been taken you can build a new kernel image and be
able to access your new Hard-disk file from Hilix itself.
