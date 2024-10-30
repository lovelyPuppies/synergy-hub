/** [🤎1] 일곱 난쟁이 ; https://www.acmicpc.net/problem/2309
 *  🏷️ tag: 브루트포스 알고리즘, 정렬
*/
/* 🔧 Usage
fn main() {
    solve(None::<std::vec::IntoIter<String>>);

    let input = "baekjoon".split_whitespace().map(String::from);
    let _result = baekjoon::seven_dwarfs_2309::solve(Some(input));
}
    solve(None::<std::vec::IntoIter<String>>);
*/

/*

total = sum(heights);

x + y  =  total − 100

x + y  =  target
*/
use std::io::{self, BufRead};

pub fn solve(input_lines: Option<impl Iterator<Item = String>>) -> String {
    // Initialize input reader
    let mut input = match input_lines {
        Some(lines) => Box::new(lines) as Box<dyn Iterator<Item = String>>,
        None => Box::new(io::stdin().lock().lines().map(|line| line.unwrap())),
    };

    // Read nine integers representing the heights of the dwarfs
    let mut heights: Vec<i32> = (0..9)
        .map(|_| input.next().unwrap().parse::<i32>().unwrap())
        .collect();

    // Calculate the total sum of the heights
    let total_sum: i32 = heights.iter().sum();
    let target: i32 = total_sum - 100;

    // Find the two heights to remove
    let mut found = false;
    let mut to_remove = (0, 0);

    'outer: for i in 0..heights.len() {
        for j in i + 1..heights.len() {
            if heights[i] + heights[j] == target {
                to_remove = (i, j);
                found = true;
                break 'outer;
            }
        }
    }

    // Remove the two outliers
    if found {
        heights.remove(to_remove.1); // Remove the higher index first
        heights.remove(to_remove.0);
    }

    // Sort the remaining dwarfs' heights
    heights.sort();

    // Format the result as a newline-separated string
    let result = heights
        .iter()
        .map(|h| h.to_string())
        .collect::<Vec<_>>()
        .join("\n");

    println!("{}", result); // Print the result (optional for testing)
    result
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_solve() {
        let test_cases = vec![
            (
                vec!["20", "7", "23", "19", "10", "15", "25", "8", "13"],
                "7\n8\n10\n13\n19\n20\n23",
            ),
            // (
            //     vec!["1", "2", "3", "4", "5", "6", "7", "8", "90"],
            //     "1\n2\n3\n4\n5\n6\n7",
            // ),
        ];

        for (input, expected) in test_cases {
            let input_lines = input.into_iter().map(String::from);
            assert_eq!(solve(Some(input_lines)), expected);
        }
    }
}
