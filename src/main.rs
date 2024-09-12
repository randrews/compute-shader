mod gpu_wrapper;
mod window_geometry;

use std::borrow::Cow;
use std::sync::{Arc, Mutex};
use wgpu::{BufferAsyncError, Maintain};
use wgpu::util::DownloadBuffer;
use winit::dpi::LogicalSize;
use winit::error::EventLoopError;
use winit::event::{Event, WindowEvent};
use crate::gpu_wrapper::GpuWrapper;

pub async fn run_window() -> Result<(), EventLoopError> {
    let event_loop = winit::event_loop::EventLoop::new().expect("Failed to create event loop!");

    let window = winit::window::WindowBuilder::new()
        .with_title("The Thing")
        .with_inner_size(LogicalSize{ width: 640, height: 480 })
        .with_min_inner_size(LogicalSize { width: 640, height: 480 })
        .with_max_inner_size(LogicalSize { width: 640, height: 480 })
        .build(&event_loop)?;

    let wrapper = GpuWrapper::new(&window).await;
    let our_id = window.id();

    event_loop.run(move |event, target| {
        match event {
            // Exit if we click the little x
            Event::WindowEvent {
                event: WindowEvent::CloseRequested,
                window_id,
            } if window_id == our_id => { target.exit(); }

            // Redraw if it's redrawing time
            Event::WindowEvent {
                event: WindowEvent::RedrawRequested,
                window_id,
            } if window_id == our_id => {
                wrapper.call_shader()
            }

            _ => {} // toss the others
        }
    })

}

pub fn main() {
    env_logger::init();
    let _ = pollster::block_on(run_window());
}
