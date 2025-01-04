public class OpenCageForwardResponseWrapper{
	public results[] results;
	public class results {
		public components components;
		public Integer confidence;	
		public String formatted;	
		public geometry geometry;
	}
	public class components {
		public String continent;	
		public String country;	
		public String country_code;	
		public String political_union;	
		public String postcode;	
	}
	public class geometry {
		public Double lat;	
		public Double lng;	
	}
	
}