classdef DataGraphic
% Handle updating a dataplot

    properties
        data1
        data2
        h
        l1
        l2
        tvec
    end
    
    methods
        
        function obj = DataGraphic(ax, data1_in, data1_str, ...
                data2_in, data2_str, tvec_in)
            
            obj.tvec = tvec_in;
            obj.data1 = data1_in;
            obj.data2 = data2_in;
            
            gca = ax;
            set(gcf,'Visible', 'off');
            [obj.h, obj.l1, obj.l2] = plotyy(obj.tvec,obj.data1,...
                obj.tvec,obj.data2);
%             tlim = ceil(obj.tvec(end));
%             % X Limits, same for both
%             xlim(obj.h(1),[0 tlim]);
%             xlim(obj.h(2),[0 tlim]);
%             % Y Limits
%             ylim(obj.h(2),[0 ylim1]);
%             ylim(obj.h(2),[0 ylim2]);

            xlim(obj.h(1),'manual')
            xlim(obj.h(2),'manual')
            ylim(obj.h(1),'manual')
            ylim(obj.h(2),'manual')

            set(obj.l1,'Xdata',0,'Ydata',0);
            set(obj.l2,'Xdata',0,'Ydata',0);
            
            grid on
            
            xlabel(obj.h(1),'Time (s)');
            ylabel(obj.h(1),data1_str);
            ylabel(obj.h(2),data2_str);
            
            set(gcf,'Visible', 'on');
        end
        
        function update(obj, t_new)
            
            [~,new_ndx] = min(abs(t_new-obj.tvec));
            data1_cur = obj.data1(1:1:new_ndx);
            data2_cur = obj.data2(1:1:new_ndx);
            set(obj.l1,'Xdata',obj.tvec(1:1:new_ndx),'Ydata',data1_cur);
            set(obj.l2,'Xdata',obj.tvec(1:1:new_ndx),'Ydata',data2_cur);
            
        end
    end
    
end