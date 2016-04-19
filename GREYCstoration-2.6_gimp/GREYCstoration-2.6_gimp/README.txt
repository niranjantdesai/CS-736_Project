-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
       ____ ____  _______   ______     _                  _   _
      / ___|  _ \| ____\ \ / / ___|___| |_ ___  _ __ __ _| |_(_) ___  _ __
     | |  _| |_) |  _|  \ V / |   / __| __/ _ \| '__/ _` | __| |/ _ \| '_ \
     | |_| |  _ <| |___  | || |___\__ \ || (_) | | | (_| | |_| | (_) | | | |
      \____|_| \_\_____| |_| \____|___/\__\___/|_|  \__,_|\__|_|\___/|_| |_|


            Open source algorithm for image denoising and interpolation,
               using state-of-the-art image processing techniques.

           ( http://www.greyc.ensicaen.fr/~dtschump/greycstoration/ )

		                      v.2.6

-----------------------------------------------------------------------------------

# Summary
#---------

GREYCstoration is an image regularization algorithm which processes an image by locally
removing small variations of pixel intensities while preserving significant global image features,
such as sharp edges and corners. The most direct application of image regularization is denoising.
By extension, it can also be used to inpaint or resize images.
GREYCstoration is based on state-of-the-art methods using nonlinear multi-valued diffusion PDE's
(Partial Differential Equations) for image regularization. This kind of method generally outperforms
basic image filtering techniques (such as convolution, median filtering, etc.), classically encountered
in painting programs. Other image denoising plugins are available (for instance, Noise Ninja, Neat Image )
but are not free, and the corresponding algorithms are kept secret.
On the contrary, GREYCstoration is distributed as an open source software, submitted to the CeCILL License
(compatible with the well-known GPL license).
It gives similar results (not to say better in certain cases) to existing denoising filters.

# Author
#--------

  David Tschumperle  ( http://www.greyc.ensicaen.fr/~dtschump/ )

  with the help of

  - David Cortesi (compiled MAC OS X Intel version + TCL script for GUI).
  - Grzegorz Szwoch (source code of the GIMP plugin).
  - Michel Talon (compiled FreeBSD version).

# Institution
#-------------

 GREYCstoration has been mainly developed in the Image group of the GREYC Lab (CNRS, UMR 6072),
 in Caen/France ( http://www.greyc.ensicaen.fr/EquipeImage/ ).

# License
#---------

 GREYCstoration is distributed under the CeCiLL license (http://www.cecill.info/index.en.html).
 The CeCiLL license is a free-software license, created under the supervision of the three biggest
 research institutions on computer sciences in France :

   - CNRS  ( http://www.cnrs.fr/ )
   - CEA   ( http://www.cea.fr/ )
   - INRIA ( http://www.inria.fr/ )

 The CeCiLL license is COMPATIBLE WITH THE GNU GPL : you can legally redistribute programs using GREYCstoration in GPL.
 You have to RESPECT this license. Please carefully read the license terms before use. In particular,
 if you are interested to distribute programs using GREYCstoration in closed-source products,
 you are invited to contact David Tschumperle (mail on his web page) to negociate a specific license.

# Integrating GREYCstoration into an open-source source code :
#--------------------------------------------------------------

 The GREYCstoration has now a simple API that provides easy integration of the algorithm into
 open source softwares. Please look at the 'src/greycstoration4integration.cpp' file, it will tell
 you almost all you have to know to get GREYCstoration working in your own code.
 This simply require you include the CImg Library + the GREYCstoration plug-in, and call a single
 function...

# About the GIMP plug-in :
#-------------------------

 The GIMP GREYCstoration plugin has been developed by Grzegorz Szwoch
 (greg(at)sound.eti.pg.gda.pl)

 The plugin is accessible from the menu : 'Filters/Enhance/GREYCstoration'

 Installation : Copy the correct file 'GREYCstoration_gimp_*' from the GREYCstoration archive
 into the GIMP's plugin directory. That's it !

 Details :

 This is an implementation of GREYCstoration algorithm as a plugin for GIMP
 (www.gimp.org). Only RESTORE mode is implemented.
 Note that there is an existing GREYCstoration plugin in the GIMP registry
 (registry.gimp.org). However, that plugin (greycstoration-0.2.0) is OBSOLETE,
 based on OLD and SLOW code, and is no longer maintained. Please do not use it !

 On the contrary, the plugin provided in this package uses the most recent
 GREYCstoration version and may be easily updated.
 The denoising process may be still slow with big images.
 If you have any questions or comments regarding the GIMP plugin, please e-mail
 greg(at)sound.eti.pg.gda.pl. Questions related to the algorithm should be sent
 to the GREYCstoration author (or, even better, use the dedicated forum on sourceforge).
 To compile the plug-in, please type 'make gimp' in the 'src/' directory.

# Package structure :
#--------------------

  The directory GREYCstoration/ is organized as follows :

  - GREYCstoration_gimp_pc_linux     : The GIMP plug-in for Linux.
  - GREYCstoration_gimp_pc_win32.exe : The GIMP plug-in for Windows.
  - GREYCstoration_pc_win32.exe      : The command line executable for Window.
  - GREYCstoration_pc_linux          : The command line executable for Linux.
  - GREYCstoration_pc_freebsd        : The command line executable for FreeBSD.
  - GREYCstoration_mac_ppc           : The command line executable for MacOS X PPC.
  - GREYCstoration_mac_intel         : The command line executable for MacOS X Intel.
  - GREYCstoration_gui.tcl           : TCL/Tk script providing a GUI to GREYCstoration
  - src/                             : The complete sources of the GREYCstoration algorithm
                                       (useful to compile on other architectures)

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
