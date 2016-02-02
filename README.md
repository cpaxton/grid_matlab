# GRID MATLAB

Grounded Robot Instruction from Demonstration project by Chris Paxton

MATLAB code for use with the Needle Master game!

### Goals

We would like to answer the question: "how can we learn a grammar of re-usable robot actions that we can use to solve complex problems in new environments?"

In particular, we examine this problem in the case of Needle Master: a simple Android game.

## Running Experiments

It is fairly simple to execute this code:

```
init
create_data % loads contents of the trials directory
learning_test_bmm % creates a simple model that determines which predicates are associated with each action
learning_segments % learns models associated with each predicate
```

You can then try a few different experiments.

### Visualize Actions

You can show the current set of actions on levels 1-12 with:

```
show_original_bmm
```

Colors correspond to different actions.
