# GRID MATLAB

Grounded Robot Instruction from Demonstration project. The goal of this project is to develop tools for learning sequences of actions from user demonstrations then generating global plans with these actions. As of March 2016, this is an outdated version of the code; the more recent (and far more powerful) version is ROS code for use with robotic manipulators.

This MATLAB code is for use with the Needle Master game available [here](https://play.google.com/store/apps/details?id=edu.jhu.lcsr.needlemaster).

[![Gameplay Example](https://img.youtube.com/vi/GgIznhbk-5g/0.jpg)](https://www.youtube.com/watch?v=GgIznhbk-5g)

More details are provided in the workshop paper [Towards Robot Task Planning From Probabilistic Models of Human Skills](http://arxiv.org/abs/1602.04754).

We would like to answer the question: "how can we learn a grammar of re-usable robot actions that we can use to solve complex problems in new environments?" Needle Master provides a simple test case for early versions of our algorithms.

Please cite as:

```
@inproceedings{paxton2016towards,
  title={Towards Robot Task Planning from Probabilistic Representations of Human Skills},
  author={Paxton, Chris and Kobilarov, Marin and Hager, Gregory D.},
  booktitle={AAAI 2016 Workshop on Planning in Hybrid Systems},
  year={2016},
  organization={AAAI}
}

@inproceedings{paxton2016want,
  title={Do what I want, not what I did: Imitation of skills by planning sequences of actions},
  author={Paxton, Chris and Jonathan, Felix and Kobilarov, Marin and Hager, Gregory D},
  booktitle={Intelligent Robots and Systems (IROS), 2016 IEEE/RSJ International Conference on},
  pages={3778--3785},
  year={2016},
  organization={IEEE}
}

```

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

First run `learning_segments` to create the action models. Then you can then try a few different experiments.

The one used for validation of the algorithm is:

```
learning_segments
levels
```

This will run the full set of experiments on randomly-generated levels.

### Visualize Actions

You can show the current set of actions on levels 1-12 with:

```
show_original_bmm
```

Colors correspond to different actions.
