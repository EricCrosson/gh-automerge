use std::env;
use std::process::{Command, exit};

fn print_usage() {
    println!("\nUsage:");
    println!("  gh arm [<number> | <url> | <branch>]");
    println!("\nOptions:");
    println!("  <number>    PR number to merge");
    println!("  <url>       PR URL to merge");
    println!("  <branch>    Branch name to merge");
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

    // Create base commands
    let mut merge_command = Command::new("gh");
    merge_command
        .arg("pr")
        .arg("merge")
        .arg("--auto")
        .arg("--merge");

    let mut ready_command = Command::new("gh");
    ready_command.arg("pr").arg("ready");

    // Add PR identifier if provided
    if args.len() > 1 {
        let pr_identifier = &args[1];
        merge_command.arg(pr_identifier);
        ready_command.arg(pr_identifier);
    }

    // Execute gh pr merge command
    let merge_status = merge_command
        .stdout(std::process::Stdio::inherit())
        .stderr(std::process::Stdio::inherit())
        .status();

    // Check if the command was successful
    match merge_status {
        Err(e) => {
            eprintln!("Failed to execute merge command: {}", e);
            exit(1);
        }
        Ok(status) if !status.success() => {
            // Exit with the same code that the command returned
            exit(status.code().unwrap_or(1));
        }
        _ => {}
    }

    // Execute gh pr ready command
    let ready_status = ready_command
        .stdout(std::process::Stdio::inherit())
        .stderr(std::process::Stdio::inherit())
        .status();

    // Check if the command was successful
    match ready_status {
        Err(e) => {
            eprintln!("Failed to execute ready command: {}", e);
            exit(1);
        }
        Ok(status) if !status.success() => {
            // Exit with the same code that the command returned
            exit(status.code().unwrap_or(1));
        }
        _ => {}
    }
}
