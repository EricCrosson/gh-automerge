use std::env;
use std::process::{Command, exit};

fn print_usage() {
    println!("\nUsage:");
    println!("  gh automerge [<number> | <url> | <branch>]");
    println!("\nOptions:");
    println!("  <number>    PR number to enable auto-merge on");
    println!("  <url>       PR URL to enable auto-merge on");
    println!("  <branch>    Branch name to enable auto-merge on");
    println!("              If no argument is provided, the current branch is used");
}

fn main() {
    let args: Vec<String> = env::args().collect();

    // Check for help flag anywhere in the arguments
    for arg in &args[1..] {
        if arg == "-h" || arg == "--help" {
            print_usage();
            exit(0);
        }
    }

    // Create command to enable auto-merge
    let mut merge_command = Command::new("gh");
    merge_command
        .arg("pr")
        .arg("merge")
        .arg("--auto")
        .arg("--merge");

    // Add PR identifier if provided
    if args.len() > 1 {
        let pr_identifier = &args[1];
        merge_command.arg(pr_identifier);
    }

    // Execute gh pr merge --auto --merge command
    let merge_status = merge_command
        .stdout(std::process::Stdio::inherit())
        .stderr(std::process::Stdio::inherit())
        .status();

    // Check if the command was successful
    match merge_status {
        Err(e) => {
            eprintln!("Failed to enable auto-merge: {}", e);
            exit(1);
        }
        Ok(status) if !status.success() => {
            // Exit with the same code that the command returned
            exit(status.code().unwrap_or(1));
        }
        _ => {}
    }
}
