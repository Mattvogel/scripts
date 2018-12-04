extern crate byteorder;
extern crate time;

//timespec yo!
use time::{Timespec,at};

//ntplib imports
pub mod ntplib;

use ntplib::retrieve_ntp_timestamp;
use ntplib::error;

// Do the thing.
fn main() {
    let timestamp :Timespec = retrieve_ntp_timestamp("0.au.pool.ntp.org").unwrap();
    println!("Internet time: {}", at(timestamp).asctime());
}
