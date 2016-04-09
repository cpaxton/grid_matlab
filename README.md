# GRID MATLAB

Grounded Robot Instruction from Demonstration project. The goal of this project is to develop tools for learning sequences of actions from user demonstrations then generating global plans with these actions. As of March 2016, this is an outdated version of the code; the more recent (and far more powerful) version is ROS code for use with robotic manipulators.

This MATLAB code is for use with the Needle Master game available [here](https://play.google.com/store/apps/details?id=edu.jhu.lcsr.needlemaster).

We would like to answer the question: "how can we learn a grammar of re-usable robot actions that we can use to solve complex problems in new environments?" In particular, we examine this problem in the case of Needle Master: a simple Android game.

[![Gameplay Example](https://img.youtube.com/vi/GgIznhbk-5g/0.jpg)](https://www.youtube.com/watch?v=GgIznhbk-5g)

## Environment Setup

It is fairly simple to execute this code:

```
init
create_data % loads contents of the trials directory
learning_test_bmm % creates a simple model that determines which predicates are associated with each action
learning_segments % learns models associated with each predicate
```

The `init` command loads pre-existing data. Then, you can optionally run the `create_data` and `learning_test_bmm` functions to create data from training files in `/trials` and set up the model that will map predicates to action primitives.

## Experiments

You can then try a few different experiments.

The one used for validation of the algorithm is:

```
levels
```

This will run the full set of experiments on randomly-generated levels.

### Visualize Actions

You can show the current set of actions on levels 1-12 with:

```
show_original_bmm
```

Colors correspond to different actions.
