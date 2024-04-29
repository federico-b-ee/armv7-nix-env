# What and Why Nix?

Nix is a powerful package manager for Linux and other Unix systems that makes package management reliable and reproducible. It aims to provide a robust and simple way to handle packages and their dependencies, ensuring that the same package setup can be replicated across multiple environments without any inconsistencies.

The key features of Nix are:

1. **Reproducibility:** Nix ensures that installing or upgrading one package cannot break other packages. It allows multiple versions of a package to coexist on the same system.

2. **Isolation:** Nix isolates packages from each other. This means that unlike traditional package managers, it doesn't have global state that can be mutated by packages.

These features make Nix an excellent tool for creating reproducible development environments, reducing the "it works on my machine" problem.

- [Nix Tutorial](https://nix.dev/tutorials/)
- [A step towards the future of configuration and infrastructure management with Nix](https://blog.container-solutions.com/step-towards-future-configuration-infrastructure-management-nix)
- [Is there much difference between using nix-shell and docker for local development? - Help - NixOS Discourse](https://discourse.nixos.org/t/is-there-much-difference-between-using-nix-shell-and-docker-for-local-development/807)
- [What is /usr/bin/env?](https://stackoverflow.com/questions/43793040/how-does-usr-bin-env-work-in-a-linux-shebang-line)
- [Nix + Make](https://www.reddit.com/r/NixOS/comments/8hefx5/nixshell_as_interpreter_for_a_makefile/)

# How

To build the `assembly` files located at `build/*.s` run:

```sh
make build
```

This make target creates a 

## Dependencies

Nix(package manager):
- [nix](https://nixos.org/download/) &rarr; installs `nix-shell`
- [nixfmt](https://github.com/NixOS/nixfmt)
