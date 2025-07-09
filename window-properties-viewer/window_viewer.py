import sys
import ctypes
from ctypes import wintypes
import tkinter as tk
from tkinter import ttk, scrolledtext
import threading
import time

# Windows API constants
GWL_STYLE = -16
GWL_EXSTYLE = -20
GW_OWNER = 4
GA_PARENT = 1
GA_ROOT = 2
GA_ROOTOWNER = 3

# Window styles
WS_OVERLAPPED = 0x00000000
WS_POPUP = 0x80000000
WS_CHILD = 0x40000000
WS_MINIMIZE = 0x20000000
WS_VISIBLE = 0x10000000
WS_DISABLED = 0x08000000
WS_CLIPSIBLINGS = 0x04000000
WS_CLIPCHILDREN = 0x02000000
WS_MAXIMIZE = 0x01000000
WS_CAPTION = 0x00C00000
WS_BORDER = 0x00800000
WS_DLGFRAME = 0x00400000
WS_VSCROLL = 0x00200000
WS_HSCROLL = 0x00100000
WS_SYSMENU = 0x00080000
WS_THICKFRAME = 0x00040000
WS_GROUP = 0x00020000
WS_TABSTOP = 0x00010000

# Extended window styles
WS_EX_DLGMODALFRAME = 0x00000001
WS_EX_NOPARENTNOTIFY = 0x00000004
WS_EX_TOPMOST = 0x00000008
WS_EX_ACCEPTFILES = 0x00000010
WS_EX_TRANSPARENT = 0x00000020
WS_EX_MDICHILD = 0x00000040
WS_EX_TOOLWINDOW = 0x00000080
WS_EX_WINDOWEDGE = 0x00000100
WS_EX_CLIENTEDGE = 0x00000200
WS_EX_CONTEXTHELP = 0x00000400
WS_EX_APPWINDOW = 0x00040000
WS_EX_LAYERED = 0x00080000
WS_EX_NOACTIVATE = 0x08000000

# Windows API functions
user32 = ctypes.windll.user32
kernel32 = ctypes.windll.kernel32

# Function prototypes
user32.GetWindowLongW.argtypes = [wintypes.HWND, ctypes.c_int]
user32.GetWindowLongW.restype = ctypes.c_long
user32.GetClassNameW.argtypes = [wintypes.HWND, wintypes.LPWSTR, ctypes.c_int]
user32.GetClassNameW.restype = ctypes.c_int
user32.GetWindowTextW.argtypes = [wintypes.HWND, wintypes.LPWSTR, ctypes.c_int]
user32.GetWindowTextW.restype = ctypes.c_int
user32.GetWindowRect.argtypes = [wintypes.HWND, ctypes.POINTER(wintypes.RECT)]
user32.GetWindowRect.restype = wintypes.BOOL
user32.GetCursorPos.argtypes = [ctypes.POINTER(wintypes.POINT)]
user32.GetCursorPos.restype = wintypes.BOOL
user32.WindowFromPoint.argtypes = [wintypes.POINT]
user32.WindowFromPoint.restype = wintypes.HWND
user32.GetForegroundWindow.restype = wintypes.HWND
user32.GetFocus.restype = wintypes.HWND
user32.GetParent.argtypes = [wintypes.HWND]
user32.GetParent.restype = wintypes.HWND
user32.GetAncestor.argtypes = [wintypes.HWND, ctypes.c_uint]
user32.GetAncestor.restype = wintypes.HWND
user32.IsWindowVisible.argtypes = [wintypes.HWND]
user32.IsWindowVisible.restype = wintypes.BOOL
user32.GetWindowThreadProcessId.argtypes = [wintypes.HWND, ctypes.POINTER(wintypes.DWORD)]
user32.GetWindowThreadProcessId.restype = wintypes.DWORD

class WindowInfo:
    def __init__(self, hwnd):
        self.hwnd = hwnd
        self.class_name = self.get_class_name()
        self.window_text = self.get_window_text()
        self.rect = self.get_window_rect()
        self.style = user32.GetWindowLongW(hwnd, GWL_STYLE) if hwnd else 0
        self.ex_style = user32.GetWindowLongW(hwnd, GWL_EXSTYLE) if hwnd else 0
        self.is_visible = bool(user32.IsWindowVisible(hwnd)) if hwnd else False
        self.process_id = self.get_process_id()
        
    def get_class_name(self):
        if not self.hwnd:
            return "N/A"
        buffer = ctypes.create_unicode_buffer(256)
        user32.GetClassNameW(self.hwnd, buffer, 256)
        return buffer.value
    
    def get_window_text(self):
        if not self.hwnd:
            return "N/A"
        length = user32.GetWindowTextLengthW(self.hwnd)
        if length == 0:
            return ""
        buffer = ctypes.create_unicode_buffer(length + 1)
        user32.GetWindowTextW(self.hwnd, buffer, length + 1)
        return buffer.value
    
    def get_window_rect(self):
        if not self.hwnd:
            return None
        rect = wintypes.RECT()
        if user32.GetWindowRect(self.hwnd, ctypes.byref(rect)):
            return rect
        return None
    
    def get_process_id(self):
        if not self.hwnd:
            return 0
        pid = wintypes.DWORD()
        user32.GetWindowThreadProcessId(self.hwnd, ctypes.byref(pid))
        return pid.value
    
    def get_style_strings(self):
        styles = []
        if self.style & WS_POPUP:
            styles.append("WS_POPUP")
        if self.style & WS_CHILD:
            styles.append("WS_CHILD")
        if self.style & WS_MINIMIZE:
            styles.append("WS_MINIMIZE")
        if self.style & WS_VISIBLE:
            styles.append("WS_VISIBLE")
        if self.style & WS_DISABLED:
            styles.append("WS_DISABLED")
        if self.style & WS_CLIPSIBLINGS:
            styles.append("WS_CLIPSIBLINGS")
        if self.style & WS_CLIPCHILDREN:
            styles.append("WS_CLIPCHILDREN")
        if self.style & WS_MAXIMIZE:
            styles.append("WS_MAXIMIZE")
        if self.style & WS_CAPTION:
            styles.append("WS_CAPTION")
        if self.style & WS_BORDER:
            styles.append("WS_BORDER")
        if self.style & WS_DLGFRAME:
            styles.append("WS_DLGFRAME")
        if self.style & WS_VSCROLL:
            styles.append("WS_VSCROLL")
        if self.style & WS_HSCROLL:
            styles.append("WS_HSCROLL")
        if self.style & WS_SYSMENU:
            styles.append("WS_SYSMENU")
        if self.style & WS_THICKFRAME:
            styles.append("WS_THICKFRAME")
        return styles
    
    def get_ex_style_strings(self):
        ex_styles = []
        if self.ex_style & WS_EX_DLGMODALFRAME:
            ex_styles.append("WS_EX_DLGMODALFRAME")
        if self.ex_style & WS_EX_NOPARENTNOTIFY:
            ex_styles.append("WS_EX_NOPARENTNOTIFY")
        if self.ex_style & WS_EX_TOPMOST:
            ex_styles.append("WS_EX_TOPMOST")
        if self.ex_style & WS_EX_ACCEPTFILES:
            ex_styles.append("WS_EX_ACCEPTFILES")
        if self.ex_style & WS_EX_TRANSPARENT:
            ex_styles.append("WS_EX_TRANSPARENT")
        if self.ex_style & WS_EX_MDICHILD:
            ex_styles.append("WS_EX_MDICHILD")
        if self.ex_style & WS_EX_TOOLWINDOW:
            ex_styles.append("WS_EX_TOOLWINDOW")
        if self.ex_style & WS_EX_WINDOWEDGE:
            ex_styles.append("WS_EX_WINDOWEDGE")
        if self.ex_style & WS_EX_CLIENTEDGE:
            ex_styles.append("WS_EX_CLIENTEDGE")
        if self.ex_style & WS_EX_CONTEXTHELP:
            ex_styles.append("WS_EX_CONTEXTHELP")
        if self.ex_style & WS_EX_APPWINDOW:
            ex_styles.append("WS_EX_APPWINDOW")
        if self.ex_style & WS_EX_LAYERED:
            ex_styles.append("WS_EX_LAYERED")
        if self.ex_style & WS_EX_NOACTIVATE:
            ex_styles.append("WS_EX_NOACTIVATE")
        return ex_styles

class WindowViewer(tk.Tk):
    def __init__(self):
        super().__init__()
        
        self.title("Window Viewer - Real-time Window Properties")
        self.geometry("1200x800")
        
        # Variables
        self.show_ancestors = tk.BooleanVar(value=True)
        self.update_interval = tk.IntVar(value=100)  # milliseconds
        self.is_updating = True
        
        # Create UI
        self.create_widgets()
        
        # Start update thread
        self.update_thread = threading.Thread(target=self.update_loop, daemon=True)
        self.update_thread.start()
        
        # Prevent window from stealing focus
        self.attributes('-topmost', True)
        self.bind('<FocusIn>', self.on_focus_in)
        
    def on_focus_in(self, event):
        # Minimize focus stealing by immediately returning focus
        pass
        
    def create_widgets(self):
        # Control panel
        control_frame = ttk.Frame(self)
        control_frame.pack(side=tk.TOP, fill=tk.X, padx=5, pady=5)
        
        ttk.Label(control_frame, text="Update Interval (ms):").pack(side=tk.LEFT, padx=5)
        ttk.Spinbox(control_frame, from_=50, to=5000, textvariable=self.update_interval, width=10).pack(side=tk.LEFT, padx=5)
        
        ttk.Checkbutton(control_frame, text="Show Ancestor Trees", variable=self.show_ancestors).pack(side=tk.LEFT, padx=20)
        
        # Create notebook for different window types
        self.notebook = ttk.Notebook(self)
        self.notebook.pack(fill=tk.BOTH, expand=True, padx=5, pady=5)
        
        # Window under mouse tab
        self.mouse_frame = ttk.Frame(self.notebook)
        self.notebook.add(self.mouse_frame, text="Window Under Mouse")
        self.mouse_text = scrolledtext.ScrolledText(self.mouse_frame, wrap=tk.WORD, font=("Consolas", 10))
        self.mouse_text.pack(fill=tk.BOTH, expand=True)
        
        # Focused window tab
        self.focus_frame = ttk.Frame(self.notebook)
        self.notebook.add(self.focus_frame, text="Focused Window")
        self.focus_text = scrolledtext.ScrolledText(self.focus_frame, wrap=tk.WORD, font=("Consolas", 10))
        self.focus_text.pack(fill=tk.BOTH, expand=True)
        
        # Active window tab
        self.active_frame = ttk.Frame(self.notebook)
        self.notebook.add(self.active_frame, text="Active Window")
        self.active_text = scrolledtext.ScrolledText(self.active_frame, wrap=tk.WORD, font=("Consolas", 10))
        self.active_text.pack(fill=tk.BOTH, expand=True)
        
        # Status bar
        self.status_var = tk.StringVar(value="Ready")
        status_bar = ttk.Label(self, textvariable=self.status_var, relief=tk.SUNKEN)
        status_bar.pack(side=tk.BOTTOM, fill=tk.X)
        
    def get_window_under_mouse(self):
        point = wintypes.POINT()
        user32.GetCursorPos(ctypes.byref(point))
        hwnd = user32.WindowFromPoint(point)
        return hwnd
    
    def get_focused_window(self):
        # Get the focused window from the foreground window's thread
        fg_window = user32.GetForegroundWindow()
        if fg_window:
            thread_id = user32.GetWindowThreadProcessId(fg_window, None)
            # Attach to the thread
            user32.AttachThreadInput(kernel32.GetCurrentThreadId(), thread_id, True)
            focused = user32.GetFocus()
            # Detach from the thread
            user32.AttachThreadInput(kernel32.GetCurrentThreadId(), thread_id, False)
            return focused
        return None
    
    def get_active_window(self):
        return user32.GetForegroundWindow()
    
    def get_ancestor_tree(self, hwnd):
        ancestors = []
        current = hwnd
        
        while current:
            info = WindowInfo(current)
            ancestors.append(info)
            
            # Get parent
            parent = user32.GetParent(current)
            if not parent:
                # Try getting owner
                parent = user32.GetWindow(current, GW_OWNER) if hasattr(user32, 'GetWindow') else None
            
            if parent == current:  # Avoid infinite loop
                break
                
            current = parent
            
        return ancestors
    
    def format_window_info(self, window_info, include_ancestors=True):
        if not window_info.hwnd:
            return "No window\n"
            
        text = []
        text.append(f"=== Window Information ===")
        text.append(f"Handle: 0x{window_info.hwnd:08X}")
        text.append(f"Class Name: {window_info.class_name}")
        text.append(f"Window Text: {window_info.window_text}")
        text.append(f"Process ID: {window_info.process_id}")
        text.append(f"Visible: {window_info.is_visible}")
        
        if window_info.rect:
            text.append(f"Position: ({window_info.rect.left}, {window_info.rect.top})")
            text.append(f"Size: {window_info.rect.right - window_info.rect.left} x {window_info.rect.bottom - window_info.rect.top}")
        
        text.append(f"\nStyle: 0x{window_info.style:08X}")
        styles = window_info.get_style_strings()
        if styles:
            text.append(f"  Flags: {', '.join(styles)}")
        
        text.append(f"\nExtended Style: 0x{window_info.ex_style:08X}")
        ex_styles = window_info.get_ex_style_strings()
        if ex_styles:
            text.append(f"  Flags: {', '.join(ex_styles)}")
        
        if include_ancestors and self.show_ancestors.get():
            text.append(f"\n\n=== Ancestor Tree ===")
            ancestors = self.get_ancestor_tree(window_info.hwnd)
            for i, ancestor in enumerate(ancestors):
                indent = "  " * i
                text.append(f"{indent}[{i}] 0x{ancestor.hwnd:08X} - {ancestor.class_name} - \"{ancestor.window_text}\"")
                if ancestor.style & WS_POPUP:
                    text.append(f"{indent}    (POPUP)")
                if ancestor.style & WS_CHILD:
                    text.append(f"{indent}    (CHILD)")
        
        return "\n".join(text)
    
    def update_window_info(self):
        try:
            # Update window under mouse
            mouse_hwnd = self.get_window_under_mouse()
            if mouse_hwnd:
                mouse_info = WindowInfo(mouse_hwnd)
                mouse_text = self.format_window_info(mouse_info)
                self.mouse_text.delete(1.0, tk.END)
                self.mouse_text.insert(1.0, mouse_text)
            
            # Update focused window
            focus_hwnd = self.get_focused_window()
            if focus_hwnd:
                focus_info = WindowInfo(focus_hwnd)
                focus_text = self.format_window_info(focus_info)
                self.focus_text.delete(1.0, tk.END)
                self.focus_text.insert(1.0, focus_text)
            else:
                self.focus_text.delete(1.0, tk.END)
                self.focus_text.insert(1.0, "No focused window detected")
            
            # Update active window
            active_hwnd = self.get_active_window()
            if active_hwnd:
                active_info = WindowInfo(active_hwnd)
                active_text = self.format_window_info(active_info)
                self.active_text.delete(1.0, tk.END)
                self.active_text.insert(1.0, active_text)
            
            self.status_var.set(f"Updated at {time.strftime('%H:%M:%S')}")
            
        except Exception as e:
            self.status_var.set(f"Error: {str(e)}")
    
    def update_loop(self):
        while self.is_updating:
            self.after(0, self.update_window_info)
            time.sleep(self.update_interval.get() / 1000.0)
    
    def on_closing(self):
        self.is_updating = False
        self.destroy()

def main():
    app = WindowViewer()
    app.protocol("WM_DELETE_WINDOW", app.on_closing)
    app.mainloop()

if __name__ == "__main__":
    main()