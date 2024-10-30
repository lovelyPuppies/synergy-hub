/** [🤎4] 알파벳 개수 ; https://www.acmicpc.net/problem/10808
 *  🏷️ tag: 구현, 문자열
*/
/* 🔧 Usage
fn main() {
    solve(None::<std::vec::IntoIter<String>>);

    let input = "baekjoon".split_whitespace().map(String::from);
    let _result = baekjoon::alphabet_count_10808::solve(Some(input));
}
    solve(None::<std::vec::IntoIter<String>>);
*/
use std::io::{self, BufRead};

pub fn solve(input_lines: Option<impl Iterator<Item = String>>) -> String {
    let mut input = match input_lines {
        Some(lines) => Box::new(lines) as Box<dyn Iterator<Item = String>>,
        None => Box::new(io::stdin().lock().lines().map(|line| line.unwrap())),
    };

    // Read the word from the input
    let word = input.next().unwrap();

    // Count occurrences of each letter (a to z)
    let mut counts = [0; 26];
    for c in word.chars() {
        if c.is_ascii_lowercase() {
            counts[(c as usize) - ('a' as usize)] += 1;
        }
    }

    // Format the counts as a space-separated string
    let result = counts
        .iter()
        .map(|&count| count.to_string())
        .collect::<Vec<_>>()
        .join(" ");
    println!("{}", result);
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let test_cases = vec![
            (
                vec!["baekjoon"],
                "1 1 0 0 1 0 0 0 0 1 1 0 0 1 2 0 0 0 0 0 0 0 0 0 0 0",
            ),
            (
                vec!["alphabet"],
                "2 1 0 0 1 0 0 1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0 0 0 0",
            ),
        ];

        for (input, expected) in test_cases {
            let input_lines = input.into_iter().map(String::from);
            assert_eq!(solve(Some(input_lines)), expected);
        }
    }
}
