use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn main() -> io::Result<()> {
    let path = Path::new("../data/01.txt");
    let file = File::open(&path)?;
    let reader = io::BufReader::new(file);

    let mut total = 0;

    for line in reader.lines() {
        let line = line?;
        let digits: Vec<_> = line.chars().filter(|c| c.is_digit(10)).collect();
        //println! ("{:?}", digits);
        if let(Some(&first), Some(&last)) = (digits.first(), digits.last()) {
            let num_str = format!("{}{}", first, last);
            if let Ok(num) = num_str.parse::<i32>() {
                total += num;
            }
        }
    }

    println!("{}", total);

    Ok(())
}
