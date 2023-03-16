public class ViaCepAddressClient extends AddressClient{

    private ViaCepAddressClient(String API_URL) {
        this.apiUrl = API_URL;
    }

    public static AddressClient create(){
        return new ViaCepAddressClient(ConfigMetadata.getURLApiBuscaCep());
    }

    private final String apiUrl;
    
    public override AddressResponse getAddress(String cep) {
        String url = apiUrl + cep + '/json/';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(url);
        request.setMethod('GET');
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            return (AddressResponse) JSON.deserialize(response.getBody(), AddressResponse.class);
        } else {
            System.debug('getAddress for ' + cep + ' not found by ViaCepAddressClient.');
            return null;
        }
    }        
    
}