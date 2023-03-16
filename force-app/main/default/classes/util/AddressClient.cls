public abstract class AddressClient {

    public abstract AddressResponse getAddress(String cep); 

    /** 
     * pseudo virtual
    */
    public static AddressClient create(){ return null; }
            
    public class AddressResponse {
        public String cep;
        public String logradouro;
        public String complemento;
        public String bairro;
        public String localidade;
        public String uf;
        public String ibge;
        public String gia;
        public String ddd;
        public String siafi;
    }

}