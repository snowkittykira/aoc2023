//#![allow(dead_code)]
//#![allow(unused_variables)]
//#![allow(unused_mut)]
//#![allow(unused_assignments)]

use std::fs;
use std::io;
use std::path::Path;

fn main() -> io::Result<()> {
    let input = fs::read_to_string(Path::new("../data/01.txt"))?;

    let mut total = 0;

    let numbers = ["1", "2", "3", "4", "5", "6", "7", "8", "9"];
    let word_numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"];
    for line in input.lines() {
        let mut first = None;
        let mut last = None;
        for (i, _) in line.char_indices() {

            for (j, num_str) in numbers.iter().enumerate() {
                if line[i..].starts_with(num_str) {
                    first = first.or(Some(j + 1));
                    last = Some(j + 1);
                }
            }

            for (j, num_str) in word_numbers.iter().enumerate() {
                if line[i..].starts_with(num_str) {
                    first = first.or(Some(j + 1));
                    last = Some(j + 1);
                }
            }
        }

        let num = first.unwrap() * 10 + last.unwrap();
        total += num;
    }

    println!("{}", total);

    Ok(())
}
