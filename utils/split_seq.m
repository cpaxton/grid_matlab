function [ segs, first, last ] = split_seq( seq, labels, k, margin )
%SPLIT_SEQ creates an array of multiple sub-sequences by splitting based on
%where labels change

if nargin < 4
    margin = 0;
end

next = 1;
segs = {};
first = {};
last = {};
seq_len = size(seq,2);

idx = find(labels == k);

if ~isempty(idx)
    split_idx = find(diff(idx)>1);
    split_idx = [0 split_idx length(idx)];
    
    for i = 2:length(split_idx)
        first_idx = max(idx(split_idx(i-1)+1)-margin,1);
        last_idx = min(idx(split_idx(i))+margin,seq_len);
        segs{next} = seq(:,first_idx:last_idx);
        first{next} = idx(split_idx(i-1)+1) - (first_idx - 1);
        last{next} = idx(split_idx(i)) - (first_idx - 1);
        next = next + 1;

    end
end

end

