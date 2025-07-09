import PyInstaller.__main__
import os
import shutil

def build_exe():
    """Build the Window Viewer executable"""
    
    # Clean previous builds
    for dir in ['build', 'dist']:
        if os.path.exists(dir):
            shutil.rmtree(dir)
    
    # PyInstaller arguments
    args = [
        'window_viewer.py',
        '--name=WindowViewer',
        '--onefile',
        '--windowed',
        '--icon=NONE',
        '--add-data=README.md;.',
        '--clean',
        '--noconfirm',
        '--disable-windowed-traceback',
        '--python-option=u',
        # Hidden imports for tkinter
        '--hidden-import=tkinter',
        '--hidden-import=tkinter.ttk',
        '--hidden-import=tkinter.scrolledtext',
    ]
    
    print("Building Window Viewer executable...")
    PyInstaller.__main__.run(args)
    
    # Also build the demo
    print("\nBuilding Demo executable...")
    demo_args = [
        'demo_popup.py',
        '--name=WindowViewerDemo',
        '--onefile',
        '--windowed',
        '--icon=NONE',
        '--clean',
        '--noconfirm',
        '--disable-windowed-traceback',
        '--hidden-import=tkinter',
    ]
    
    PyInstaller.__main__.run(demo_args)
    
    print("\nBuild complete!")
    print("Executables are in the 'dist' folder:")
    print("  - WindowViewer.exe")
    print("  - WindowViewerDemo.exe")

if __name__ == "__main__":
    build_exe()