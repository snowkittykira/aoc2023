//#![allow(dead_code)]
//#![allow(unused_variables)]
//#![allow(unused_mut)]
//#![allow(unused_assignments)]

use std::fs;
use std::path::Path;
use regex::Regex;

#[derive(Debug)]
struct Location {
    x: usize,
    y: usize
}

#[derive(Debug)]
struct Token<'a> {
    from: Location,
    to: Location,
    body: &'a str
}

fn index_to_location (index: usize, line_length: usize) -> Location {
    return Location {
        x: index % line_length,
        y: index / line_length,
    }
    
}

fn find_all_with_locations (input: &str, line_length: usize, pat: Regex) -> Vec<Token> {
    let mut tokens: Vec<Token> = vec![];
    for captures in pat.captures_iter(&input) {
        let capture = captures.get(0).unwrap();
        let token = Token {
            from: index_to_location (capture.start(), line_length),
            // move to down by 1 line so it's properly 1 past the end
            to: index_to_location (capture.end()+line_length, line_length),
            body: capture.as_str(),
        };
        tokens.push(token)
    }
    tokens
}

fn are_adjacent (a: &Token, b: &Token) -> bool {
  a.from.x <= b.to.x && b.from.x <= a.to.x &&
      a.from.y <= b.to.y && b.from.y <= a.to.y
}

fn part_1 (numbers: &Vec<Token>, symbols: &Vec<Token>) -> usize {
    numbers.iter().filter(|n| {
        symbols.iter().any(|s| {
            are_adjacent (n, s)
        })
    }).map(|n| {
        n.body.parse::<usize>().unwrap()
    }).sum()
}

fn part_2 (numbers: &Vec<Token>, symbols: &Vec<Token>) -> usize {
    let mut total = 0;
    for s in symbols {
        let mut num_count = 0;
        let mut product = 1;
        for n in numbers {
            if are_adjacent(s, n) {
                num_count += 1;
                product *= n.body.parse::<usize>().unwrap();
            }
        }
        if num_count == 2 {
            total += product;
        }
    }
    total
}

fn main () {
    let input = fs::read_to_string(Path::new("../data/03.txt")).unwrap();

    let num_regex = Regex::new(r"\d+").unwrap();
    let sym_regex = Regex::new(r"[^\d\.]").unwrap();

    // line length including newline
    let line_length = input.lines().next().unwrap().len() + 1;

    let numbers = find_all_with_locations(&input, line_length, num_regex);
    let symbols = find_all_with_locations(&input, line_length, sym_regex);

    //println!("{:#?}",numbers);
    //println!("{:#?}",symbols);
    println!("part 1: {}", part_1(&numbers, &symbols));
    println!("part 2: {}", part_2(&numbers, &symbols));
}
