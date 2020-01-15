.zshrc.d
========
This folder is a modular zshrc file.

Behavior
--------
1. Sources the scripts into the environment in numeric order.
2. Only sources scripts that are either marked as "base", the current HOST, or the current USER.
3. If there are two with the same number, the one that is most specific will be preferred.
  (user, host, base is the order of specificity.)

Modification
------------

To modify the behavior of a module it is recommended that one not replace the existing one.
Instead one should create a file with the next index marked as for one's system.
If instead one does decided to replace a base module, one should read the changes made to the file replaced as to not miss updates three of.