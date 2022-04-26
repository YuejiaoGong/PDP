function fImg = RecoverFrame(noFrameImg, frameRecord)


h = frameRecord(1);
w = frameRecord(2);

top = frameRecord(3);
bot = frameRecord(4);
left = frameRecord(5);
right = frameRecord(6);

[partialH, partialW] = size(noFrameImg); 

fill_value = 0;

if partialH ~= h || partialW ~= w
    feaImg = ones(h, w) * fill_value;
    feaImg(top:bot, left:right) = noFrameImg;
    fImg = feaImg;
else
    fImg = noFrameImg;
end

