module mux_axi #(parameter DW=8)(
  
  input clk,
  input resetn,
  
  input [DW-1:0] s_axis_data0,
  input s_axis_valid0,
  input s_axis_last0,
  output reg s_axis_ready0,
  
  input [DW-1:0] s_axis_data1,
  input s_axis_valid1,
  input s_axis_last1,
  output reg  s_axis_ready1,
  
  input sel,

  output reg [DW-1:0] m_axis_data,
  output reg  m_axis_valid,
  output reg  m_axis_last,
  input m_axis_ready



);
  
  
  always@(posedge clk or negedge resetn)
    	begin
          if(~resetn)
            	begin
                  	m_axis_data<=8'bz;
                  m_axis_valid<=1'bz;
                   	m_axis_last<=1'bz;
                end
          else if((~sel) && s_axis_valid0 && s_axis_ready0)
            	begin
                  	m_axis_data<=s_axis_data0;
                  	m_axis_valid<=s_axis_valid0;
                  	m_axis_last<=s_axis_last0;
                end
          else if(sel && s_axis_valid1 && s_axis_ready1)
            	begin
                  	m_axis_data<=s_axis_data1;
                  	m_axis_valid<=s_axis_valid1;
                  	m_axis_last<=s_axis_last1;
                end
          else
            	begin
                  	m_axis_data<=0;
                  	m_axis_valid<=0;
                  	m_axis_last<=0;
                end
        end
  
  
  always@(*)
    	begin
          if(~resetn)	
            begin
              	s_axis_ready1='z;
              	s_axis_ready0='z;
            end
          else if(sel)
           	   begin
                s_axis_ready1=m_axis_ready;
              	s_axis_ready0=0;
               end
          else if(~sel)
            	begin
                s_axis_ready1=0;
              	s_axis_ready0=m_axis_ready;
                end
          else
            	begin
                  s_axis_ready1=0;
              	  s_axis_ready0=0;
                end
        end  
                  	
            	
              	
              	
endmodule            	
  
  
  
  
  
  
  
  
  
  
  
  