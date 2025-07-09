import tkinter as tk
from tkinter import messagebox
import time

def create_popup():
    """Create a popup window that disappears when it loses focus"""
    popup = tk.Toplevel(root)
    popup.title("Focus-Sensitive Popup")
    popup.geometry("300x200+500+300")
    popup.attributes('-topmost', True)
    
    # Make it a popup style window
    popup.overrideredirect(True)
    
    # Add content
    frame = tk.Frame(popup, bg='lightblue', bd=2, relief=tk.RAISED)
    frame.pack(fill=tk.BOTH, expand=True, padx=2, pady=2)
    
    tk.Label(frame, text="This is a popup window", bg='lightblue', font=("Arial", 14)).pack(pady=20)
    tk.Label(frame, text="It will disappear when it loses focus", bg='lightblue').pack()
    tk.Label(frame, text="Use Window Viewer to inspect it!", bg='lightblue').pack()
    
    # Close button
    tk.Button(frame, text="Close", command=popup.destroy, bg='white').pack(pady=10)
    
    # Bind focus out event to destroy the popup
    popup.bind('<FocusOut>', lambda e: popup.destroy())
    
    # Focus the popup
    popup.focus_force()

def create_tooltip():
    """Create a tooltip-style window"""
    tooltip = tk.Toplevel(root)
    tooltip.wm_overrideredirect(True)
    tooltip.wm_geometry("+600+400")
    tooltip.attributes('-topmost', True)
    
    label = tk.Label(tooltip, text="Tooltip Window\n(WS_EX_TOOLWINDOW style)", 
                     bg='yellow', relief=tk.SOLID, borderwidth=1)
    label.pack()
    
    # Auto-destroy after 5 seconds
    tooltip.after(5000, tooltip.destroy)

def create_layered():
    """Create a semi-transparent layered window"""
    layered = tk.Toplevel(root)
    layered.title("Layered Window")
    layered.geometry("250x150+700+300")
    layered.attributes('-alpha', 0.7)  # Semi-transparent
    layered.attributes('-topmost', True)
    
    tk.Label(layered, text="Semi-transparent\nLayered Window", 
             font=("Arial", 16), bg='lightgreen').pack(expand=True, fill=tk.BOTH)
    
    tk.Button(layered, text="Close", command=layered.destroy).pack(pady=10)

# Main window
root = tk.Tk()
root.title("Window Viewer Demo")
root.geometry("400x300")

tk.Label(root, text="Window Viewer Demo", font=("Arial", 16, "bold")).pack(pady=20)
tk.Label(root, text="Create different types of windows to test:").pack(pady=10)

tk.Button(root, text="Create Focus-Sensitive Popup", command=create_popup, 
          width=30, height=2).pack(pady=5)
tk.Button(root, text="Create Tooltip Window", command=create_tooltip, 
          width=30, height=2).pack(pady=5)
tk.Button(root, text="Create Layered Window", command=create_layered, 
          width=30, height=2).pack(pady=5)

tk.Label(root, text="\nRun Window Viewer to inspect these windows\nwithout changing their focus!", 
         fg="blue").pack(pady=20)

root.mainloop()